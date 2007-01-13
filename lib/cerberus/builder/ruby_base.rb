require 'cerberus/builder/base'

class Cerberus::Builder::RubyBase
  include Cerberus::Utils
  attr_reader :output

  def initialize(config, cmd)
    @config = config
    @cmd = cmd
  end

  def run
    Dir.chdir @config[:application_root]
    @output = `#{@config[:bin_path]}#{choose_exec()} #{@config[:builder, @cmd.to_sym, :task]} 2>&1`
    successful?
  end

  def successful?
    $?.exitstatus == 0 and not @output.include?("#{@cmd} aborted!")
  end

  def brokeness
    if @output =~ /\d+ tests, \d+ assertions, (\d+) failures, (\d+) errors/
      $1.to_i + $2.to_i
    else
      0
    end
  end

  private
  def choose_exec
    ext = ['']

    if os() == :windows 
      ext << '.bat' << '.cmd'
    end

    silence_stream(STDERR) {
      ext.each do |e|
        begin
          out = `#{@config[:bin_path]}#{@cmd}#{e} --version 2>&1`
          return "#{@cmd}#{e}" if out =~ /#{@cmd}/
        rescue
        end
      end
    }

    raise "#{@cmd} builder did not find. Make sure that such script exists and have executable permissions."
  end
end
