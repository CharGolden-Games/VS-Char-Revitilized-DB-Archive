package backend;

// code used for looking at how the git repo is atm
using StringTools;

#if !display
class GitVer
{
    // git commit shit :D

    public static macro function getGitComHash():haxe.macro.Expr.ExprOf<String>
    {
        #if !display
        // line num
        var pos = haxe.macro.Context.currentPos();
        
        var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
        if (process.exitCode() != 0)
        {
            var message = process.stderr.readAll().toString();
            haxe.macro.Context.info("Couldn't get Git commit?! This must not be a proper repo!", pos);
        }

        //now onto the processing
        var commitHash:String = process.stdout.readLine();
        var commitHashSplice:String = commitHash.substr(0, 7);

        trace('Git ID: ${commitHashSplice}');

        //make it a string expression!
        return macro $v{commitHashSplice};
        #else
        // dont call it on display
        var commitHash:String = "";
        return macro $v{commitHashSplice};
        #end
    }

    public static macro function getGitBranch():haxe.macro.Expr.ExprOf<String>
    {
        #if !display
        // line num
        var pos = haxe.macro.Context.currentPos();
        var isDevBranch:Bool;
        
        var branchProcess = new sys.io.Process('git', ['rev-parse', '--abbrev-ref', 'HEAD']);
        if (branchProcess.exitCode() != 0)
        {
            var message = branchProcess.stderr.readAll().toString();
            haxe.macro.Context.info("Couldn't get Git commit?! This must not be a proper repo!", pos);
        }

        var gitProcess = new sys.io.Process('git', ['remote', '-v']);
        if (gitProcess.exitCode() != 0)
          {
              var message = branchProcess.stderr.readAll().toString();
              haxe.macro.Context.info("Couldn't get Git commit?! This must not be a proper repo!", pos);
          }
        
        var branchName:String = branchProcess.stdout.readLine();
        if (StringTools.contains(Std.string(gitProcess.stdout.readLine()).toLowerCase(), 'dev-branch')) branchName = 'Dev Branch ' + branchName;
        trace('Git Branch: ${branchName}');

        // stringy expressions.
        return macro $v{branchName};
        #else
        // dont call on display
        var branchName:String = '';
        return macro $v{branchName};
        #end
    }

    static var hasChanges:Bool = false;
    public static macro function getGitHasLocalChanges():haxe.macro.Expr.ExprOf<Bool>
      {
        #if !display
        // Get the current line number.
        var pos = haxe.macro.Context.currentPos();
        var branchProcess = new sys.io.Process('git', ['status', '--porcelain']);
    
        if (branchProcess.exitCode() != 0)
        {
          var message = branchProcess.stderr.readAll().toString();
          haxe.macro.Context.info('[WARN] Could not determine current git commit; is this a proper Git repository?', pos);
        }
    
        var output:String = '';
        try
        {
          output = branchProcess.stdout.readLine();
        }
        catch (e)
        {
          if (e.message == 'Eof')
          {
            // Do nothing.
            // Eof = No output.
          }
          else
          {
            // Rethrow other exceptions.
            throw e;
          }
        }
        if (output.length > 0) hasChanges = true;
        trace('Git Status Output: $hasChanges');
    
        // Generates a string expression
        return macro $v{output.length > 0};
        #else
        // `#if display` is used for code completion. In this case we just assume true.
        return macro $v{true};
        #end
      }
}
#end
