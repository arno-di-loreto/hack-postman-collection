def print_item(parent_level):
  (parent_level + "#") as $level |
  $level + " " + .name + "\n"
  + .description  + "\n"
  + (if .request then 
      .request.description + "\n"
      + (.event | map(
                      if .listen == "prerequest" and (.script.exec | join("") | length > 0) then
                      $level + "# Pre-request Script\n\n"
                      + "{% code title:\"Pre-request Script\" language:json %}\n"
                      + (.script.exec | join("\n"))
                      + "{% endcode %}\n"
                      else
                      ""
                      end
                  ) 
        | join("\n")
      )
      + $level + "# Request and response\n"
      + "{% code title:Request language:http %}\n"
      + (.response[0].originalRequest.url.raw | gsub("&";"\n&")) + "\n"
      + "{% endcode %}\n" 
      + "\n"
      + "{% code title:Response language:json %}\n"
      + .response[0].body + "`\n"
      + "{% endcode %}\n" 
    else "" end)
  + (if .item then .item | map(print_item($level)) | join("\n") else "" end)
;

  "---\n"
+ "title: " + .info.name + "\n"
+ "author: Arnaud Lauret" + "\n"
+ "layout: post" + "\n"
+ "permalink: /" + (.info.name | ascii_downcase | gsub("\b";"-")) + "/\n"
+ "category: post" + "\n"
+ "---\n\n"
+ (.info.description | sub("\n#";"\n<!--more-->\n\n#") | gsub("\n> ⛔️ (?<alert>.*\\.\n)";("\n{% include alert.html content=\""+ .alert +"\" level=\"danger\" %}\n");"m")) + "\n\n"
+ (.item | map(. | print_item("")) | join("\n"))