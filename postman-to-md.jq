def print_item(parent_level):
  (parent_level + "#") as $level |
  $level + " " + .name + "\n"
  + .description  + "\n"
  + (if .request then 
      .request.description + "\n"
      + (.event | map(
                      if .listen == "prerequest" and (.script.exec | join("") | length > 0) then
                      $level + "# Pre-request Script\n"
                      + "```js\n"
                      + (.script.exec | join("\n"))
                      + "```\n"
                      else
                      ""
                      end
                  ) 
        | join("\n")
      )
      + $level + "# Request and response\n"
      + "```\n"
      + (.response[0].originalRequest.url.raw | gsub("&";"\n&")) + "\n"
      + "```\n"
      + "\n"
      + "```json\n"
      + .response[0].body + "`\n"
      + "```\n" 
    else "" end)
  + (if .item then .item | map(print_item($level)) | join("\n") else "" end)
;

"# " + .info.name + "\n"
+ .info.description + "\n"
+ (.item | map(. | print_item("#")) | join("\n"))