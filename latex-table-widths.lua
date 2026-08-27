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
