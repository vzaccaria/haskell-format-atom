HaskellFormat = require '../lib/haskell-format'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "HaskellFormat", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('haskell-format')

  describe "when the haskell-format:toggle event is triggered", ->
    it "should do something", ->
      expect(true).toBe false
      
