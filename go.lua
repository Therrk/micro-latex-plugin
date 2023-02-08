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
	shell.ExecCommand("bash", "-c", "pdflatex -interaction=nonstopmode -file-line-error " .. filename .. ".tex | grep \"^\\./\"", "&")
	-- return compil_errors
end

function display(filename)
	shell.JobStart("xpdf -rv " .. filename .. ".pdf", test,test,test, nil)
	-- return display_errors
end

function test(std, userargs)
end
