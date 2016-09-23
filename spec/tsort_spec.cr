require "./spec_helper"

describe TSort do
  describe "dag" do
    it "should sort correctly" do
      h = {1=>[2, 3], 2=>[3], 3=>[] of Int32}
      h.tsort.should eq([3, 2, 1])
    end
  end

  describe "cycle" do
    it "should handle TSort::Cyclic correctly" do
      h = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[] of Int32}
      expect_raises(TSort::Cyclic) { h.tsort }
    end
  end

  describe "array" do
    it "should interate strongly connected components with correct order" do
      a = [[1], [0], [0], [2]]
      actual = a.strongly_connected_components.map { |component| component.sort }
      actual.should eq([[0, 1], [2], [3]])
    end
  end

  describe "#tsort" do
    it "should sort correctly" do
      g = {1=>[2, 3], 2=>[4], 3=>[2, 4], 4=>[] of Int32}
      g.tsort.should eq([4, 2, 3, 1])
    end

    it "should handle TSort::Cyclic correctly" do
      g = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[] of Int32}
      expect_raises(TSort::Cyclic) { g.tsort }
    end
  end
end
