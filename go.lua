local shell = import("micro/shell")
local buffer = import("micro/buffer")

function onSave(bp)
	if bp.Buf:fileType()=="tex" then
		filename = bp.Buf:GetName()
		shell.RunCommand("xdg-open " .. string.sub(filename,1,#filename-3) .. "pdf |grep \"^\./\"" .. filename .."tex")
		shell.RunCommand("pdflatex -interaction=nonstopmode ".. filename)
	end
end
