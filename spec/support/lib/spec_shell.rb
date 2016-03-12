require 'open3'

class SpecShell
  attr_accessor :stdout
  attr_accessor :stderr

  #Will execute right away
  def initialize *args, timeout: 0.5
    @timeout = timeout
    @args = args

    @stdout = []
    @stderr = []
    @exit_status = nil

    @did_timeout = false

    execute
  end

  def execute
    Open3.popen3 *@args do |_stdin, _stdout, _stderr, wt|
      @pid = wt[:pid] #Capture pid now as it will be unavailable later

      begin
        Timeout::timeout(@timeout) do
          res = select [_stdout, _stderr], [], []
          res.flatten.each do |p|
            case p
            when _stdout
              @stdout << p.read
            when _stderr
              @stderr << p.read
            end
          end
        end
      rescue Timeout::Error
        @did_timeout = true
      rescue => e
      ensure
        unless @did_timeout
          @exit_status = wt.value
        end
        cleanup
      end
    end
  end

  def timed_out?
    return @did_timeout
  end

  def exit_value
    return @exit_status.exitstatus if @exit_status
    return nil
  end

  def succeeded?
    exit_value == 0
  end

  def failed?
    exit_value != 0 && exit_value != nil && @did_timeout == false
  end

  def cmd
    return @args[0]
  end

  def inspect
    stdout = @stdout.map{|e| "[stdout]: #{e}"}.join("\n")
    stderr = @stderr.map{|e| "[stderr]: #{e}"}.join("\n")
    str = <<HERE
#{"-"*100}
shell>#{@args.join(" ")}
#{stdout}
#{stderr}
#{"-"*100}
HERE
    "\n" + str.split("\n").select{|e| e != ""}.join("\n") + "\n"
  end

  private
  def cleanup
    Process.kill :KILL, @pid if @pid
  rescue Errno::ESRCH
  rescue
  end
end
