# File to transform
$file = "{filename}.xml"

# Update node
[xml]$xml = (Get-Content $file)
$node = $xml.Parameters.setParameter | where {$_.name -eq 'CelsiaContext-Web.config Connection String'}
$node.value = ""
$xml.Save($file)