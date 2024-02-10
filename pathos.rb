# frozen_string_literal: true
require 'pastel'
require 'shellwords'
require 'tty-reader'
require 'tty-command'
require 'tty-prompt'

class Pathos
  def initialize
    @prompt  = TTY::Prompt.new
    @command = TTY::Command.new
    @pastel  = Pastel.new
    @paths   = init_paths
    @reader  = TTY::Reader.new
    @help    = File.read('help.txt')
    @error   = ''
    @selected_index = 0
  end

  def run
    loop do
      clear_screen
      key = @reader.read_keypress

      if key == 'q'
        yes = @prompt.yes?('Save your changes?')
        save_env_file if yes
        break
      end

      handle_key_event(key)
    end
  end

  def paths_from_env
    return false if File.exist?(env_file)

    ENV['PATH'].split(':')
  end

  def env_file_contents
    File.read(env_file).sub('export PATH=', '').strip
  end

  def paths_from_env_file
    env_file_contents.split(':')
  end

  def init_paths
    paths_from_env or paths_from_env_file
  end

  def handle_key_event(key)
    case key
    when :up, 'k'
      @selected_index -= 1 unless @selected_index.zero?
    when :down, 'j'
      @selected_index += 1 unless @selected_index == @paths.length - 1
    when 'o'
      insert_path(false)
    when 'O'
      insert_path(true)
    when 'x'
      remove_path
    when 'X'
      remove_nonexistent_paths
    when 'D'
      remove_duplicate_paths
    when 'S'
      save_env_file
    end
  end

  def env_file
    "#{ENV['HOME']}/.pathos.env"
  end

  def quoted_paths
    @paths.map { |path| Shellwords.escape path }
  end

  def export_text
    "export PATH=#{quoted_paths.join(':')}"
  end

  def save_env_file
    File.open(env_file, 'w+') { |file| file.puts export_text }
  end

  def insert_path(above)
    path = @prompt.ask('Enter new path:')
    if Dir.exist? path
      index = above ? @selected_index : @selected_index + 1
      @paths.insert(index, path)
      @selected_index = index
    else
      @error = "pathos.rb ERROR: #{path} does not exist"
    end
  end

  def remove_path
    @paths.delete_at(@selected_index)
    @selected_index = [@selected_index, @paths.length - 1].min
  end

  def remove_nonexistent_paths
    @paths.select! { |path| Dir.exist?(path) }
  end

  def remove_duplicate_paths
    @paths = @paths.uniq
  end

  def display_title
    puts "\n\n  pathos - CLI for editing a PATH env variable\n\n"
  end

  def clear_screen
    system('clear') || system('cls')
    display_title
    display_paths_menu
  end

  def default_colors
    { color: :white, background: :on_black, style: :clear }
  end

  def display_error
    return unless @error
    @prompt.error @error
    @error = ''
  end

  def display_paths_menu
    @paths.each_with_index do |path, index|
      color, background, style = default_colors.values_at(:color, :background, :style)

      unless Dir.exist?(path)
        color = :red
        style = :strikethrough
      end

      if @paths.count(path) > 1
        color = :cyan
        style = :italic
      end

      if index == @selected_index
        color = :yellow
        style = :bold
      end

      cursor = index == @selected_index ? '>' : ' '
      puts @pastel.decorate("#{cursor} #{index + 1}. #{path}", color, background, style)
    end

    puts @help
    display_error
  end
end

Pathos.new.run
