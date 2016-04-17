class Hiera
  module Backend
    class Osxkeychain_backend
      class Keychain
        SECURITY_PATH="/usr/bin/security"

        attr_reader :service

        def initialize(service = nil)
          @service = service
        end

        def lookup(options = {})
          # See security(1) for these arguments.
          args = ["-w"]

          if service
            args += ["-s", service]
          end

          account = options[:account]
          if account
            args += ["-a", account]
          end

          label = options[:label]
          if label
            args += ["-l", label]
          end

          command = [SECURITY_PATH, "find-generic-password"] + args
          status, out, error = run(*command)
          if status.success?
            out.chomp
          else
            Hiera.warn("Fail to lookup #{options}: #{error.chomp}")
            nil
          end
        end

        private

        # Fork and exec command, then return stdout, stderr and exit status.
        # There are no such methods working on all ruby versions.
        def run(*cmd)
          Hiera.debug("exec #{cmd.join(" ")}")

          pipes = [IO.pipe, IO.pipe]

          stdout_read, stdout_write = pipes[0]
          stderr_read, stderr_write = pipes[1]

          pid = fork do
            stdout_read.close
            stderr_read.close
            STDOUT.reopen(stdout_write)
            STDERR.reopen(stderr_write)

            # Close file descriptors on exec(3).
            # This is for ruby prior to 1.9.1.
            set_close_on_exec

            # Give `:close_others` option for ruby 1.9.x.
            # This is by default on ruby 2.0.x and later.
            exec(*(cmd + [{:close_others => true}]))
          end
          stdout_write.close
          stderr_write.close
          _, status = Process.waitpid2(pid)

          return [status, stdout_read.read, stderr_read.read]
        ensure
          pipes.flatten.each do |io|
            io.close unless io.closed?
          end
        end

        def set_close_on_exec
          ObjectSpace.each_object(IO) do |io|
            if ![STDIN, STDOUT, STDERR].include?(io) && !io.closed?
              io.fcntl(Fcntl::F_SETFD, Fcntl::FD_CLOEXEC) rescue SystemCallError
            end
          end
        end
      end

      def initialize
        @config = Config[:osxkeychain]
        Hiera.debug("osxkeychain_backend initialized config: #{@config}")
      end

      def lookup(key, scope, order_override, resolution_type, *args)
        # Ignore order_override since it doesn't not have hierarchy.
        # Ignore scope since no need to interpolate values in anyways.

        # Use key for account to lookup generic password.
        result = keychain.lookup(:account => key)

        # Hiera 2 and later, which has 5th argument, require to throw `:no_such_key`
        # when no key found, but Hiera 1 requires to return `nil`.
        if !result && !args.empty?
          throw(:no_such_key)
        end

        case resolution_type
        when :array
          if result
            [result]
          else
            []
          end
        when :hash
          Hiera.warn("Unexpected resolution type.")
          result
        else
          result
        end
      end

      private

      def keychain
        @keychain ||= Keychain.new(@config[:service] || "hiera")
      end
    end
  end
end
