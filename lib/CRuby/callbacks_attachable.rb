dir = File.dirname File.dirname __FILE__
Dir[File.join(dir, 'all', '**', '*.rb')].sort.each{ |f| require f }
Dir[File.join(dir, 'CRuby', '**', '*.rb')].sort.each{ |f| require f }