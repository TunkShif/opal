def foo(bar)
  puts "Hello, ", bar
end

class Foo
  def initialize(@foo)
  end

  def bar
    puts @foo
  end

  def self.foobar
    puts "foobar"
  end
end

module Bar
  def foo
  end

  def self.bar(foobar)
    puts foobar
  end
end

class Foobar
  def initialize(@foobar)
  end
end

enum Types
  A
  B
  C
  def types
    puts "foobar"
  end
end

def Foobar.foo
  puts "foo"
end
