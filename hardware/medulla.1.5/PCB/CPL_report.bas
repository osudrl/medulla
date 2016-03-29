' Sample 17: Excel Part List Report.BAS
' 
'This is a completely revised version of the same file renamed to: old_X & Y Part Location Report.bas
'This script has been generated by PowerPCB's VB Script Wizard on 8/23/2007 3:19:25 PM
'It will create reports in Microsoft Excel Format.
'You can use the following code as a skeleton for your own VB scripts

'Array of column names. You can modify it to rename columns
'Const Columns = Array("PartType", "RefDes", "PartDecal", "Pins", "Layer", "Orient.", "X", "Y", "SMD", "Glued")
Const Columns = Array("Designator", "Footprint", "Mid X", "Mid Y", "Ref X", "Ref Y", "Pad 1 X", "Pad 1 Y", "Layer", "Rotation")

Sub Main
	tempFile = DefaultFilePath & "\temp.txt"
	Open tempFile For Output As #1

	'Output table header
	For i = 0 to UBound(Columns)
		OutCell Columns(i)
	Next
	Print #1
	'Output table rows
	For Each part In ActiveDocument.Components
		OutCell part.Name
		OutCell part.Decal
		OutCell Format(part.CenterX, "0.000")
		OutCell Format(part.CenterY, "0.000")
		OutCell Format(part.PositionX, "0.000")
		OutCell Format(part.PositionY, "0.000")
		OutCell Format(part.Pins(1).PositionX, "0.000")
		OutCell Format(part.Pins(1).PositionY, "0.000")
		If (part.layer = 1) Then
			OutCell "T"
		Else
			OutCell "B"
		End If
		OutCell part.Orientation
		Print #1
	Next part

	Close #1
	FillClipboard
End Sub

Sub ExportToExcel
	FillClipboard
	Dim xl As Object
	On Error Resume Next
	Set xl =  GetObject(,"Excel.Application")
	On Error GoTo ExcelError	' Enable error trapping.
	If xl Is Nothing Then
		Set xl =  CreateObject("Excel.Application")
	End If
	xl.Visible = True
	xl.Workbooks.Add
	xl.Range("A:C").NumberFormat = "@"
	xl.Range("D1:J1").NumberFormat = "@"
	xl.ActiveSheet.Paste
	xl.Range("A1:J1").Font.Bold = True
	xl.Range("A1:J1").NumberFormat = "@"
	xl.ActiveSheet.UsedRange.Columns.AutoFit
	xl.Range("A1").Select
	On Error GoTo 0 ' Disable error trapping. 
	Exit Sub    

ExcelError:
	MsgBox Err.Description, vbExclamation, "Error Running Excel"
	On Error GoTo 0 ' Disable error trapping.    
	Exit Sub
End Sub

Sub OutCell (txt As String)
	Print #1, txt; ",";
End Sub

Sub FillClipboard
	' Load whole file to string variable    
	tempFile = DefaultFilePath & "\temp.txt"
	Open tempFile  For Input As #1
	L = LOF(1)
	AllData$ = Input$(L,1)
	Close #1
	'Copy whole data to clipboard
	Clipboard AllData$ 
	Kill tempFile
End Sub