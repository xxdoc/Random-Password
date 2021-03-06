Attribute VB_Name = "Mod_QBase64"
Option Explicit
'【代码协会 VB通用模块库】CodeInstitute VB Common Modules Library
'【模块名】QBase64 加密解密算法
'【作者】CI Deali-Axy

Function Base64Encode(Str() As Byte) As String                                  'Base64 编码
    On Error GoTo over                                                          '排错
    Dim buf() As Byte, length As Long, mods As Long
    Const B64_CHAR_DICT = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
    mods = (UBound(Str) + 1) Mod 3
    length = UBound(Str) + 1 - mods
    ReDim buf(length / 3 * 4 + IIf(mods <> 0, 3, 0))
    Dim i As Long
    For i = 0 To length - 1 Step 3
        buf(i / 3 * 4) = (Str(i) And &HFC) / &H4
        buf(i / 3 * 4 + 1) = (Str(i) And &H3) * &H10 + (Str(i + 1) And &HF0) / &H10
        buf(i / 3 * 4 + 2) = (Str(i + 1) And &HF) * &H4 + (Str(i + 2) And &HC0) / &H40
        buf(i / 3 * 4 + 3) = Str(i + 2) And &H3F
    Next
    If mods = 1 Then
        buf(length / 3 * 4) = (Str(length) And &HFC) / &H4
        buf(length / 3 * 4 + 1) = (Str(length) And &H3) * &H10
        buf(length / 3 * 4 + 2) = 64
        buf(length / 3 * 4 + 3) = 64
    ElseIf mods = 2 Then
        buf(length / 3 * 4) = (Str(length) And &HFC) / &H4
        buf(length / 3 * 4 + 1) = (Str(length) And &H3) * &H10 + (Str(i + 1) And &HF0) / &H10
        buf(length / 3 * 4 + 2) = (Str(length) And &HF) * &H4
        buf(length / 3 * 4 + 3) = 64
    End If
    For i = 0 To UBound(buf)
        Base64Encode = Base64Encode + Mid(B64_CHAR_DICT, buf(i) + 1, 1)
    Next
over:
End Function

Function Base64Uncode(B64 As String) As Byte()                                  'Base64 解码
    On Error GoTo over                                                          '排错
    Dim OutStr() As Byte, i As Long, j As Long
    Const B64_CHAR_DICT = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
    If InStr(1, B64, "=") <> 0 Then B64 = Left(B64, InStr(1, B64, "=") - 1)     '判断Base64真实长度,除去补位
    Dim length As Long, mods As Long
    mods = Len(B64) Mod 4
    length = Len(B64) - mods
    ReDim OutStr(length / 4 * 3 - 1 + Switch(mods = 2, 1, mods = 3, 2))
    For i = 1 To length Step 4
        Dim buf(3) As Byte
        For j = 0 To 3
            buf(j) = InStr(1, B64_CHAR_DICT, Mid(B64, i + j, 1)) - 1
        Next
        OutStr((i - 1) / 4 * 3) = buf(0) * &H4 + (buf(1) And &H30) / &H10
        OutStr((i - 1) / 4 * 3 + 1) = (buf(1) And &HF) * &H10 + (buf(2) And &H3C) / &H4
        OutStr((i - 1) / 4 * 3 + 2) = (buf(2) And &H3) * &H40 + buf(3)
    Next
    If mods = 2 Then
        OutStr(length / 4 * 3) = (InStr(1, B64_CHAR_DICT, Mid(B64, length + 1, 1)) - 1) * &H4 + ((InStr(1, B64_CHAR_DICT, Mid(B64, length + 2, 1)) - 1) And &H30) / 16
    ElseIf mods = 3 Then
        OutStr(length / 4 * 3) = (InStr(1, B64_CHAR_DICT, Mid(B64, length + 1, 1)) - 1) * &H4 + ((InStr(1, B64_CHAR_DICT, Mid(B64, length + 2, 1)) - 1) And &H30) / 16
        OutStr(length / 4 * 3 + 1) = ((InStr(1, B64_CHAR_DICT, Mid(B64, length + 2, 1)) - 1) And &HF) * &H10 + ((InStr(1, B64_CHAR_DICT, Mid(B64, length + 3, 1)) - 1) And &H3C) / &H4
    End If
    Base64Uncode = OutStr                                                       '读取解码结果
over:
End Function
