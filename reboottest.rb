result = run_command("shutdown -r now", error: false)
if result.exit_status == 1 then
  p "hoge success"
else
  p "hoge failed"
  exit(0);
end
     
