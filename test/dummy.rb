class Dummy
  attr_reader :greeting

  def speak
    puts "Dummy says #{greeting}"
  end

  def greeting=(greeting)
    @greeting = greeting << "!!!"
  end
end

Dummy.new.tap { |d| d.greeting = "Ahoi!"}.speak