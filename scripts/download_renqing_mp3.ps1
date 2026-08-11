# 批量下载仁青公众号音频到 D:\仁青
$OutDir = "D:\仁青"
$Urls = @(
    "https://mp.weixin.qq.com/s/4hgXYmhnQwoilHPs22igjg",
    "https://mp.weixin.qq.com/s/hPpLb4wvtylAY-pium8OEg",
    "https://mp.weixin.qq.com/s/u_BAU0s1FLImBz923soQzw",
    "https://mp.weixin.qq.com/s/Son6NAOecPYjwjzqCU6nfw",
    "https://mp.weixin.qq.com/s/vvfMjfUMc6kSjzjsbm1SSw",
    "https://mp.weixin.qq.com/s/_8KP4y31WYZp0LjvfnqCjg",
    "https://mp.weixin.qq.com/s/mh1L9mI9edjSCqK-FfgM_g",
    "https://mp.weixin.qq.com/s/PYae8s4I0tkN-COv5E8zSA",
    "https://mp.weixin.qq.com/s/-Lhha_8eDUz9nENIFiPjgA",
    "https://mp.weixin.qq.com/s/9TjNS1YHLkiCISwMGjhSAw",
    "https://mp.weixin.qq.com/s/g-Fl_cjyCJaDCQwKsuJCEQ",
    "https://mp.weixin.qq.com/s/WJOnshpUBG9vYoPUoyZtFQ"
)
$Ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

for ($i = 0; $i -lt $Urls.Count; $i++) {
    $url = $Urls[$i]
    $idx = "{0:D2}" -f ($i + 1)
    Write-Host "[$idx/$($Urls.Count)] $url"
    $html = Invoke-WebRequest -Uri $url -UserAgent $Ua -UseBasicParsing
    $text = $html.Content
    if ($text -notmatch 'voice_encode_fileid="([^"]+)"') {
        Write-Warning "  未找到音频 ID，跳过"
        continue
    }
    $mediaId = $Matches[1]
    $name = "audio"
    if ($text -match 'name="([^"]+)"') { $name = $Matches[1] -replace '&nbsp;', ' ' }
    $safe = ($name -replace '[\\/:*?"<>|\s]+', '_').Trim('._')
    if ($safe.Length -gt 80) { $safe = $safe.Substring(0, 80) }
    $out = Join-Path $OutDir "$idx`_$safe.mp3"
    $audioUrl = "https://res.wx.qq.com/voice/getvoice?mediaid=$mediaId"
    Invoke-WebRequest -Uri $audioUrl -UserAgent $Ua -Headers @{ Referer = $url } -OutFile $out
    Write-Host "  已保存: $out"
    Start-Sleep -Seconds 1
}

Write-Host "全部完成，文件位于 $OutDir"
