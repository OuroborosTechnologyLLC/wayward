-- The HTML edition contains a hand-written contents list. Pandoc creates the
-- native navigation document used by PDF and EPUB readers, so omit the HTML
-- copy from exported editions to avoid displaying two tables of contents.

local function opens_contents_nav(block)
    return block.t == "RawBlock" and
        block.format:match("html") and
        block.text:match("<nav[^>]-id=[\"']contents[\"']")
end

local function closes_nav(block)
    return block.t == "RawBlock" and
        block.format:match("html") and
        block.text:match("</nav%s*>")
end

function Pandoc(document)
    local blocks = {}
    local inside_contents_nav = false
    local skip_contents_list = false

    for _, block in ipairs(document.blocks) do
        if opens_contents_nav(block) then
            inside_contents_nav = true
        elseif inside_contents_nav and closes_nav(block) then
            inside_contents_nav = false
        elseif inside_contents_nav then
            -- Skip every block in the authored HTML navigation element.
        elseif block.t == "Header" and
            block.identifier == "contents-heading" then
            -- Raw HTML is disabled for LaTeX input, so the nav wrapper is not
            -- present. Remove its heading and the list that immediately follows.
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
