module TSort
  class Cyclic < ::Exception
  end
  class NotImplementedError < ::Exception
  end

  def tsort
    components = [] of Int32 | Array(Int32)
    each_strongly_connected_component do |component|
      if component.size == 1
        components << component.first
      else
        raise Cyclic.new("topological sort failed: #{component.inspect}")
      end
    end
    components
  end

  def strongly_connected_components
    components = [] of Array(Int32)
    each_strongly_connected_component do |component|
      components << component
    end
    components
  end

  def tsort_each_node
    raise NotImplementedError
  end

  def tsort_each_child
    raise NotImplementedError
  end

  private def each_strongly_connected_component(&block : Array(Int32) -> _) : Nil
    id_map = {} of Int32 => Int32 | Nil
    stack  = [] of Int32

    tsort_each_node do |node|
      unless id_map.has_key?(node)
        each_strongly_connected_component_from(node, id_map, stack) do |child|
          block.call(child)
        end
      end
    end
  end

  private def each_strongly_connected_component_from(node, id_map, stack, &block : Array(Int32) -> _) : Int32
    minimum_id = node_id = id_map[node] = id_map.size
    stack_length = stack.size
    stack << node

    tsort_each_child(node) do |child|
      if id_map.has_key?(child)
        child_id = id_map[child]
        minimum_id = child_id if child_id && child_id < minimum_id
      else
        sub_minimum_id =
          each_strongly_connected_component_from(child, id_map, stack) do |child|
            block.call(child)
          end
        minimum_id = sub_minimum_id if sub_minimum_id < minimum_id
      end
    end

    if node_id == minimum_id
      component = stack[stack_length..-1]
      stack.delete_at(stack_length..-1)
      component.each { |n| id_map[n] = nil }
      block.call(component)
    end

    minimum_id
  end
end
