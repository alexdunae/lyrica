require 'sequel'

class Lyrica
  attr_accessor :db
  @db_dir = ''

  def initialize(db_dir = nil)
    @db_dir = db_dir || Dir.pwd
    connect
  end

  # Load all the <tt>*.crd</tt> files in the given directory in to
  # the database.
  #
  # If <tt>purge</tt> is true then the database is purged before loading.
  def load!(data_dir, purge = false)
    purge! if purge

    charts = @db[:charts]

    Dir.glob("#{data_dir}/*.crd").each do |fn|
      chart_data = load_file(fn)
      chart = charts.insert(chart_data)
    end
  end
  
  def purge!
    @db.execute('DELETE FROM charts;')
  end
  
  def artists
    @db[:charts].group_and_count(:artist)
  end
  
  def charts(filter = nil)
    filter ? @db[:charts].filter(filter) : @db[:charts].all
  end

private
  def connect
    @db = Sequel.connect(ENV['DATABASE_URL'] || 'mysql://test:test@localhost/lyrica')
    @db.create_table? :charts do
      primary_key :id
      String      :artist,     :index => true
      String      :title
      String      :filename,   :index => true
      Text        :content
    end
    @db
  end

  def load_file(fn)
    parts = File.basename(fn, '.*').split(/[\s]+\-[\s]+/, 2)
    
    if parts.length == 2
      out = {:artist => parts[0], :title => parts[1]}
    else
      out = {:artist => 'unknown', :title => parts[0]}
    end

    out[:filename] = File.basename(fn)
    
    file = File.open(fn, 'r')
    out[:content] = file.read
    
    out
  end
end
