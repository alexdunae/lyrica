require File.join(File.dirname(__FILE__), '../lyrica')
require 'test/unit'

class TestLyrica < Test::Unit::TestCase
  TEST_DATA_DIR = File.expand_path(File.join(File.dirname(__FILE__), '../data'))
  
  def test_loading
    lyrica = Lyrica.new
    assert_equal 3, lyrica.charts.count

    lyrica.load! TEST_DATA_DIR
    assert_equal 6, lyrica.charts.count

    lyrica.load! TEST_DATA_DIR, true
    assert_equal 3, lyrica.charts.count
  end
  
  def test_finding
    lyrica = Lyrica.new
    assert_equal 2, lyrica.charts(:artist => 'beatles').count
    assert_equal 1, lyrica.charts(:artist => 'unknown').count
    assert_equal 0, lyrica.charts(:artist => 'nobody').count
  end
  
  def test_artists
     lyrica = Lyrica.new
     assert_equal 2, lyrica.artists.count
  end
  
  def setup
    lyrica = Lyrica.new
    lyrica.load!(TEST_DATA_DIR, true)
  end
  
  def teardown
    # TODO: delete db
  end
end