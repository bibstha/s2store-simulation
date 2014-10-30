def log(values, filename = "output")
  File.open("logs/#{filename}", 'a') do |f|
    f.puts Array(values).join("\t")
  end
end

def reset_logs(filenames = ['output'])
  Array(filenames).each { |filename| File.open("logs/#{filename}", 'w') {} }
end