return {
   name = 'Simple',
   priority = 1000,
   --- @param bufnr integer
   enabled = function(bufnr)
     return true
   end,
   --- @param params Hover.Provider.Params
   --- @param done fun(result?: false|Hover.Result)
   execute = function(params, done)
     done{lines={'TEST'}, filetype="markdown"}
   end
}
