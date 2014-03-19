define ["lib/jasmine/src/notepad"], (notepad) ->
    describe "returns titles", ->
        it "something", ->
            expect(notepad.noteTitles()).toEqual("pick up the kids get milk ")
