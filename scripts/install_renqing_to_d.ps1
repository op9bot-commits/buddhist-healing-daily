# 一键安装仁青 MP3 到 D:\仁青（从 GitHub Release 下载）
$ErrorActionPreference = 'Stop'
$OutDir = 'D:\仁青'
$ReleaseUrl = 'https://github.com/op9bot-commits/buddhist-healing-daily/releases/download/renqing-mp3/renqing-mp3.zip'
$TempZip = Join-Path $env:TEMP 'renqing-mp3.zip'

Write-Host '正在创建目录 D:\仁青 ...'
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

Write-Host '正在从 GitHub 下载音频包 ...'
Invoke-WebRequest -Uri $ReleaseUrl -OutFile $TempZip -UseBasicParsing

Write-Host '正在解压到 D:\仁青 ...'
Expand-Archive -Path $TempZip -DestinationPath $OutDir -Force
Remove-Item $TempZip -Force

$count = (Get-ChildItem -Path $OutDir -Filter '*.mp3').Count
Write-Host "完成！共 $count 个 MP3 文件已保存到 $OutDir"
explorer.exe $OutDir
