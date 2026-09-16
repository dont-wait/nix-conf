local M = {}
local active
local namespace = vim.api.nvim_create_namespace("repeat-motion-scroll")

-- Restore the logical destination before executing another command.
function M.finish()
    local state = active
    if not state then
        return
    end
    active = nil
    state.timer:stop()
    state.timer:close()
    vim.on_key(nil, namespace)
    if vim.api.nvim_win_is_valid(state.win) and vim.api.nvim_win_get_buf(state.win) == state.buf then
        vim.api.nvim_win_call(state.win, function()
            vim.fn.winrestview(state.target)
        end)
    end
end

function M.begin()
    -- Keep the displayed frame when retargeting, but execute the next motion at
    -- the previous destination so counts and direction retain native semantics.
    local before = vim.fn.winsaveview()
    M.finish()
    return before
end

function M.animate(win, buf, before)
    if vim.api.nvim_get_current_win() ~= win or vim.api.nvim_get_current_buf() ~= buf
        or vim.fn.mode() ~= "n" or vim.fn.reg_executing() ~= "" then
        return
    end
    -- Force the native motion's viewport calculation before taking its final view.
    vim.fn.winline()
    local target = vim.fn.winsaveview()
    if (before.topline == target.topline and before.skipcol == target.skipcol)
        or before.leftcol ~= target.leftcol then
        return
    end

    local state = { win = win, buf = buf, target = target, timer = vim.uv.new_timer() }
    active = state
    local started = vim.uv.hrtime()
    local distance = math.abs(target.topline - before.topline)
    local duration = math.min(360, 220 + distance * 2) * 1000000
    vim.fn.winrestview(before)
    vim.on_key(function(key, typed)
        -- Repeats (including counts) retarget without displaying the old endpoint.
        -- Lua mappings arrive as an internal key code; inspect the typed key.
        local input = typed and typed ~= "" and typed or key
        if not input:match("^[;,0-9]$") then
            M.finish()
        end
    end, namespace)
    state.timer:start(0, 8, vim.schedule_wrap(function()
        if active ~= state then
            return
        end
        if vim.api.nvim_get_current_win() ~= win or vim.api.nvim_get_current_buf() ~= buf
            or vim.fn.mode() ~= "n" then
            M.finish()
            return
        end
        local progress = math.min((vim.uv.hrtime() - started) / duration, 1)
        if progress == 1 then
            M.finish()
            return
        end
        local eased = progress * progress * (3 - 2 * progress)
        local view = vim.deepcopy(before)
        for _, field in ipairs({ "topline", "lnum", "col" }) do
            view[field] = math.floor(before[field] + (target[field] - before[field]) * eased + 0.5)
        end
        view.skipcol = math.floor(before.skipcol + (target.skipcol - before.skipcol) * eased + 0.5)
        vim.fn.winrestview(view)
        vim.cmd.redraw()
    end))
end

return M
