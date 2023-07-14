local debug_mode = false

for _, v in pairs(arg) do
    if v == '--debug' then
        debug_mode = true
        break
    end
end

local shell = import("micro/shell")
local buffer = import("micro/buffer")

--- Executes specific actions when a buffer is saved.
--- @param bp any The buffer object representing the saved file.
function onSave(bp)
    if bp.Buf:fileType() == "tex" then
        filename = bp.Buf:GetName()
        filename = string.sub(filename, 1, #filename - 4)
        compile(filename)
        display(filename)
    end
end

--- This function is called when a buffer pane is opened. It checks if the file type of the buffer is "tex" (TeX file). If it is, the function performs a series of operations to handle the TeX file, including retrieving the filename, truncating the file extension, compiling the TeX file, and displaying the compiled output.
function onBufPaneOpen(bp)
    if bp.Buf:fileType() == "tex" then
        local filename = bp.Buf:GetName()
        filename = string.sub(filename, 1, #filename - 4)
        compile(filename)
        display(filename)
    end
end

--- Compiles a LaTeX file specified by `filename` using `pdflatex` command. If debugging is enabled, it clears all existing messages in the buffer and adds a new error message at line 1. The function returns the error messages if `debug_mode` is enabled.
--- @param filename string The name of the LaTeX file to compile.
--- @return string? @If debugging is enabled, it returns the error messages as a string.
function compile(filename)
    errors = shell.ExecCommand("bash", "-c", "pdflatex -interaction=nonstopmode -file-line-error " .. filename .. ".tex | grep \"^\\./\"", "&")
    if debug_mode then
        buffer.ClearAllMessages()
    end
    message = shell.NewMessageAtLine("tex", "oh la la", 1, buffer.MTError)
    buffer:AddMessages(message)
    if debug_mode then
        display_errors(errors)
        return compil_errors
    end
end

--- Executes a command to display a PDF file using `xpdf`. The function starts a shell job that invokes `xpdf` with the provided filename. It also supports a remote control feature to open the specified PDF file within `xpdf`.
--- @param filename string The path to the PDF file.
function display(filename)
    shell.JobStart("xpdf -rv -remote " .. filename .. " \"openFile(" .. filename .. ".pdf)\"", test, test, test, nil)
    if debug_mode then
        return display_errors
    end
end

--- Displays errors from a string containing error messages.
--- @param errors string A string containing error messages.
function display_errors(errors)
    for line in errors:gmatch("([^\n]*)\n?") do
        line_number, message = select(3, string.find(line, "(%d+):(.*)"))
        if line_number == nil then
            shell.NewMessageAtLine("tex", message, tonumber(line_number), MTError)
        end
    end
end

function test(std, userargs)

end

function isOpen(filename)

end
