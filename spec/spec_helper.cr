require "../src/tsort"
require "spec"

class Hash
  include TSort

  def tsort_each_node(&block)
    each_key do |key|
      yield key
    end
  end

  def tsort_each_child(node, &block)
    fetch(node).each do |value|
      yield value
    end
  end
end

class Array
  include TSort

  def tsort_each_node(&block)
    each_index do |index|
      yield index
    end
  end

  def tsort_each_child(node, &block)
    at(node).each do |value|
      yield value
    end
  end
  def tsort_each_node
    each_index
  end

  def tsort_each_child(node, block)
    fetch(node).each(block)
  end
end
