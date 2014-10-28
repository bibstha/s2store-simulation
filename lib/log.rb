def log(values, filename = "output")
  File.open("logs/filename", 'a') do |f|
    f.puts Array(values).join(", ")
  end
end