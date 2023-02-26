local shell = import("micro/shell")
local buffer = import("micro/buffer")

function onSave(bp)
	if bp.Buf:fileType()=="tex" then
		filename = bp.Buf:GetName()
		filename = string.sub(filename,1,#filename-4)
		compile(filename)
		display(filename)
	end
end

function onBufPaneOpen(bp)
	if bp.Buf:fileType() == "tex" then
		local filename = bp.Buf:GetName()
		filename = string.sub(filename,1,#filename-4)
		compile(filename)
		display(filename)
	end
end

function compile(filename)
	errors = shell.ExecCommand("bash", "-c", "pdflatex -interaction=nonstopmode -file-line-error " .. filename .. ".tex | grep \"^\\./\"", "&")
	-- buffer.ClearAllMessages()
	message = shell.NewMessageAtLine("tex", "oh la la", 1, buffer.MTError)
	buffer:AddMessages(message)
	-- display_errors(errors)
	-- return compil_errors
end

function display(filename)
	shell.JobStart("xpdf -rv -remote " .. filename .. " \"openFile("..filename..".pdf)\"", test,test,test, nil)
	-- return display_errors
end

function display_errors(errors)
	for line in errors:gmatch("([^\n]*)\n?") do
		_,_,line_number, message = string.find(line, "(%d+):(.*)")
		if line_number==nil then
			shell.NewMessageAtLine("tex", message, tonumber(line_number), MTError)
		end
	end
end

function test(std, userargs)
end

function isOpen(filename)
	
end
