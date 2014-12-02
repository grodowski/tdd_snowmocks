class Stack  
  def initialize
    @elements = []
  end
  
  def size 
    @elements.size
  end
  
  def push(element)
    @elements << element
  end
  
  def pop
    @elements.pop
  end
end