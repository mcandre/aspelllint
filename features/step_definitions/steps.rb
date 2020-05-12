Given(/^the program has finished$/) do
    @cucumber = `aspelllint examples/`
    @cucumber_ignores = `aspelllint -i '*.md' examples/`
    @cucumber_stdin = `aspelllint < examples/toy-boats.txt`
    @cucumber_personal = `aspelllint -p ./examples/.aspell.en.pws examples/toy-boats.txt`
end

Then(/^the output is correct for each test$/) do
    cucumber_lines = @cucumber.split("\n")
    expect(cucumber_lines.length).to eq(2)
    expect(cucumber_lines[0]).to match(%r(^examples/nested/memo\.md\:.+Fribsday.+$))
    expect(cucumber_lines[1]).to match(%r(^examples/toy-boats\.txt\:.+baots.+$))

    cucumber_ignores = @cucumber_ignores.split("\n")
    expect(cucumber_ignores.length).to eq(1)
    expect(cucumber_ignores[0]).to match(%r(^examples/toy-boats\.txt\:.+baots.+$))

    cucumber_lines_stdin = @cucumber_stdin.split("\n")
    expect(cucumber_lines_stdin.length).to eq(1)
    expect(cucumber_lines_stdin[0]).to match(%r(^stdin\:.+baots.+$))

    lines_personal = @cucumber_personal
    expect(lines_personal.length).to eq(0)
end

def valid_json?(json)
    begin
        JSON.parse(json)
        return true
    rescue JSON::ParserError => e
        return false
    end
end
