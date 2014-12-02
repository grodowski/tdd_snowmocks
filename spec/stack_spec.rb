require 'stack'

describe Stack do 
  subject { Stack.new } 
  let(:element) { :element }
  
  it 'has size eq 0' do 
    expect(subject.size).to eq 0
  end
  
  context 'after push' do 
    before do
      subject.push element
    end
    
    it 'has size 1 after push' do 
      expect(subject.size).to eq 1
    end
  
    it 'has size 0 after pop' do 
      subject.pop
      expect(subject.size).to eq 0
    end
  
    it 'pop returns last element' do 
      expect(subject.pop).to eq element
    end
  end
  
  it 'pops elements in reverse order' do 
    subject.push element
    subject.push :element_2
    expect(subject.pop).to eq :element_2
    expect(subject.pop).to eq element
  end
end