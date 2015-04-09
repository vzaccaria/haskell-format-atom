{CompositeDisposable} = require 'atom'
Subscriber = require('emissary').Subscriber
_ = require('lodash')
promise = require('bluebird')
uid = require('uid')
os = require('os')
shelljs = require('shelljs')

packageName = "haskell-format"
language = "source.haskell"

execStdIn = (cmd, stdin) ->
  dname = os.tmpdir()
  filename = "#{dname}/#{uid(8)}"
  stdin.to("#{filename}.in")
  console.log stdin
  command = "< #{filename}.in #{cmd} > #{filename}.out"
  console.log command
  return new promise (resolve, reject) ->
    shelljs.exec command, (code, output) ->
      if code == 0
        resolve(shelljs.cat("#{filename}.out"))
      else
        console.error(output)
        reject(code)


doIt = (editor) ->
  if editor.getGrammar()?.scopeName is language
    style = atom.config.get("#{packageName}.style")
    cmd = "haskell-formatter"
    execStdIn(cmd, editor.getText()).then (newText) ->
      editor.setText(newText)

onSave = () ->
  if atom.config.get("#{packageName}.onSave")
    doIt(atom.workspace.activePaneItem)

plugin = module.exports

Subscriber.extend(plugin)

plugin.config =
    onSave:
      type: 'boolean'
      default: true
      description: "Format on save"
    style:
      type: 'string'
      default: 'fundamental'
      description: "Formatting style name, one of (fundamental|chris-done|johan-tibell|gibiansky)"

plugin.activate = (state) ->
  atom.commands.add('atom-workspace', "#{packageName}:toggle", => @toggle())
  atom.workspace.eachEditor (editor) ->
    buffer = editor.getBuffer()
    plugin.unsubscribe(buffer)
    plugin.subscribe(buffer, 'saved', _.debounce(onSave, 50))

plugin.deactivate = ->

plugin.toggle = ->
  doIt(atom.workspace.activePaneItem)
