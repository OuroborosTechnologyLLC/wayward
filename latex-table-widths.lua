-- HTML tables normally arrive without column widths, which makes LaTeX use
-- unwrapped l/r/c columns. Give each column an equal share of the text width
-- so long equipment and rules tables remain on the page. Adjust this filter
-- later if particular tables need custom proportions.

function Table(table)
    local column_count = #table.colspecs

    if column_count == 0 then
        return table
    end

    local column_width = 1 / column_count
    for index = 1, column_count do
        table.colspecs[index][2] = column_width
    end

    return table
end

-- The HTML editions contain a hand-written linked contents list. Pandoc also
-- creates a proper PDF table of contents (with page numbers), so omit the HTML
-- copy from LaTeX to avoid printing two contents sections.
function Pandoc(document)
    local blocks = {}
    local skip_contents_list = false

    for _, block in ipairs(document.blocks) do
        if block.t == "Header" and block.identifier == "contents" then
            skip_contents_list = true
        elseif skip_contents_list and
            (block.t == "BulletList" or block.t == "OrderedList") then
            skip_contents_list = false
        else
            table.insert(blocks, block)
        end
    end

    document.blocks = blocks
    return document
end
