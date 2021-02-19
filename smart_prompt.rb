class SmartPrompt

  def self.get_input(prompt, default)
    print "#{prompt} [default: #{default}]: "
    input = gets.chomp
    $stdout.flush

    if input.empty?
      return default
    else
      return input
    end
  end
end
