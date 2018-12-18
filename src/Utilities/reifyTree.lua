-- Takes an array of nodes with a `parent` and `id` field and returns a
-- tree based on this structure. The tree nodes have the following
-- structure:
--
--    {
--      children: TreeNode[],
--      parent: TreeNode,
--      node: Node, -- The object from the array.
--    }
--
-- Returns a reference to the root node.

local function reifyTree(nodes, rootId)
	local treeNodes = {}

	for i = 1, #nodes do
		local node = nodes[i]
		treeNodes[node.id] = {
			children = {},
			node = node,
		}
	end

	for i = 1, #nodes do
		local node = nodes[i]
		local treeNode = treeNodes[node.id]

		if node.parent then
			local parentTreeNode = treeNodes[node.parent]
			parentTreeNode.children[#parentTreeNode.children + 1] = treeNode

			treeNode.parent = parentTreeNode
		end
	end

	return treeNodes[rootId]
end

return reifyTree
