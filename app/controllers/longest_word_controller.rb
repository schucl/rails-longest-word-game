class LongestWordController < ApplicationController
  def ask
    @grid_array = generate_grid(15)
    @start_time = Time.now()
  end

  def result
    @answer = params[:answer]
    @grid_array = params[:grid].split("")
    @start_time = params[:start_time].to_datetime
    @end_time = Time.now()
    @score = run_game(@answer, @grid_array, @start_time, @end_time)
  end

  private

  def generate_grid(grid_size)
    grid_array = []
    for i in (0..grid_size - 1)
      grid_array << ("A".."Z").to_a.sample
    end
    return grid_array
  end

  def run_game(answer, grid, start_time, end_time)
    binding.pry
    answer = answer.upcase
    words = File.read('/usr/share/dict/words').upcase.split("\n")
    if answer.split("") && grid.split == answer.split("")
      if words.include?(answer)
        translation = call_api_translation(answer)
        message = "well done"
        score = answer.length + (100 - (end_time - start_time))
      else
        message = "not an english word"
        score = 0
        translation = nil
      end
    else
      message = "not in the grid"
      score = 0
      translation = nil
    end
    p score
    result = {
      time: end_time - start_time,
      score: score,
      translation: translation,
      message: message
    }
  end

  def call_api_translation(input)
    url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=bcecb76e-251f-413e-b4ff-d762c3dcc708&input=#{input}"
    translation = JSON.parse(open(url).read)
    return translation["outputs"][0]["output"]
  end
end
