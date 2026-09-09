local M = {}
local last_motion

-- Remember the chosen direction; repeating backwards does not change it.
function M.pair(forward, backward)
    local function wrap(action, opposite)
        return function()
            last_motion = { action, opposite }
            if type(action) == "string" then
                return action
            end
            return action()
        end
    end
    return wrap(forward, backward), wrap(backward, forward)
end

function M.repeat_callback(index)
    last_motion[index]()
end

function M.setup()
    local modes = { "n", "x", "o" }
    for _, keys in ipairs({ { "}", "{" }, { ")", "(" }, { "n", "N" } }) do
        local forward, backward = M.pair(keys[1], keys[2])
        vim.keymap.set(modes, keys[1], forward, { expr = true, desc = "Next repeatable motion" })
        vim.keymap.set(modes, keys[2], backward, { expr = true, desc = "Previous repeatable motion" })
    end

    for _, key in ipairs({ "f", "F", "t", "T" }) do
        vim.keymap.set(modes, key, function()
            last_motion = nil
            return key
        end, { expr = true })
    end

    for index, key in ipairs({ ";", "," }) do
        vim.keymap.set(modes, key, function()
            if not last_motion then
                return key
            end
            local action = last_motion[index]
            if type(action) == "string" then
                return action
            end
            -- Cursor-changing callbacks must run outside expression-map evaluation.
            return "<Cmd>lua require('repeat-motion').repeat_callback(" .. index .. ")<CR>"
        end, { expr = true, desc = index == 1 and "Repeat last motion" or "Repeat last motion backwards" })
    end
end

return M
