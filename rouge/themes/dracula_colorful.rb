# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Themes
    class DraculaColorful < CSSTheme
      name 'dracula_colorful'

      # Standard Palette
      palette :background   =>  '#282A36'
      palette :foreground   =>  '#F8F8F2'
      palette :selection    =>  '#44475A'
      palette :comment      =>  '#6272A4'
      palette :red          =>  '#FF5555'
      palette :orange       =>  '#FFB86C'
      palette :yellow       =>  '#F1FA8C'
      palette :green        =>  '#50FA7B'
      palette :purple       =>  '#BD93F9'
      palette :cyan         =>  '#8BE9FD'
      palette :pink         =>  '#FF79C6'

      palette :red_comment  =>  '#FF6E6E'
      palette :tbd          =>  '#000000', :bold => true
      palette :tbd2         =>  '#ffffff', :bold => true

      # ANSI Palette
      palette :ansi_black           =>  '#21222C'
      palette :ansi_red             =>  '#FF5555'
      palette :ansi_green           =>  '#50FA7B'
      palette :ansi_yellow          =>  '#F1FA8C'
      palette :ansi_blue            =>  '#BD93F9'
      palette :ansi_magenta         =>  '#FF79C6'
      palette :ansi_cyan            =>  '#8BE9FD'
      palette :ansi_white           =>  '#F8F8F2'
      palette :ansi_bright_black    =>  '#6272A4'
      palette :ansi_bright_red      =>  '#FF6E6E'
      palette :ansi_bright_green    =>  '#69FF94'
      palette :ansi_bright_yellow   =>  '#FFFFA5'
      palette :ansi_bright_blue     =>  '#D6ACFF'
      palette :ansi_bright_magenta  =>  '#FF92DF'
      palette :ansi_bright_cyan     =>  '#A4FFFF'
      palette :ansi_bright_white    =>  '#FFFFFF'

      # Dracula Styles
      style Text,                           :fg => :foreground, :bg => :background
      style Text::Whitespace,               :fg => :tbd
      style Escape,                         :fg => :tbd
      style Error,                          :fg => :red
      style Other,                          :fg => :tbd
      style Keyword,                        :fg => :pink
      style Keyword::Constant,              :fg => :tbd
      style Keyword::Declaration,           :fg => :tbd
      style Keyword::Namespace,             :fg => :tbd
      style Keyword::Pseudo,                :fg => :pink
      style Keyword::Reserved,              :fg => :tbd
      style Keyword::Type,                  :fg => :tbd
      style Keyword::Variable,              :fg => :tbd
      style Name,                           :fg => :green
      style Name::Attribute,                :fg => :cyan
      style Name::Builtin,                  :fg => :purple, :italic => true
      style Name::Builtin::Pseudo
      style Name::Class,                    :fg => :purple
      style Name::Constant,                 :fg => :cyan
      style Name::Decorator,                :fg => :tbd
      style Name::Entity,                   :fg => :tbd
      style Name::Exception,                :fg => :tbd
      style Name::Function,                 :fg => :green
      style Name::Function::Magic,          :fg => :tbd
      style Name::Property,                 :fg => :tbd
      style Name::Label,                    :fg => :cyan
      style Name::Namespace,                :fg => :purple
      style Name::Other,                    :fg => :tbd
      style Name::Tag,                      :fg => :foreground
      style Name::Variable,                 :fg => :cyan
      style Name::Variable::Class,          :fg => :purple
      style Name::Variable::Global,         :fg => :cyan
      style Name::Variable::Instance,       :fg => :orange
      style Name::Variable::Magic,          :fg => :tbd
      style Literal,                        :fg => :foreground
      style Literal::Date,                  :fg => :tbd
      style Literal::String,                :fg => :yellow
      style Literal::String::Affix,         :fg => :tbd
      style Literal::String::Backtick,      :fg => :yellow
      style Literal::String::Char,          :fg => :tbd
      style Literal::String::Delimiter,     :fg => :tbd
      style Literal::String::Doc,           :fg => :tbd
      style Literal::String::Double,        :fg => :yellow
      style Literal::String::Escape,        :fg => :pink
      style Literal::String::Heredoc,       :fg => :tbd
      style Literal::String::Interpol,      :fg => :yellow, :bold => true
      style Literal::String::Other,         :fg => :yellow
      style Literal::String::Regex,         :fg => :yellow
      style Literal::String::Single,        :fg => :yellow
      style Literal::String::Symbol,        :fg => :purple
      style Literal::Number,                :fg => :purple
      style Literal::Number::Bin,           :fg => :tbd
      style Literal::Number::Float,         :fg => :purple
      style Literal::Number::Hex,           :fg => :tbd
      style Literal::Number::Integer,       :fg => :purple
      style Literal::Number::Integer::Long, :fg => :purple
      style Literal::Number::Oct,           :fg => :tbd
      style Literal::Number::Other,         :fg => :pink
      style Operator,                       :fg => :foreground
      style Operator::Word,                 :fg => :tbd
      style Punctuation,                    :fg => :foreground
      style Punctuation::Indicator,         :fg => :foreground
      style Comment,                        :fg => :red_comment, :bold => true, :italic => true
      style Comment::Hashbang,              :fg => :red, :bold => true
      style Comment::Doc,                   :fg => :tbd
      style Comment::Multiline,             :fg => :red_comment, :bold => true, :italic => true
      style Comment::Preproc,               :fg => :tbd
      style Comment::PreprocFile,           :fg => :tbd
      style Comment::Single,                :fg => :red_comment, :bold => true, :italic => true
      style Comment::Special,               :fg => :tbd
      style Generic,                        :fg => :tbd
      style Generic::Deleted,               :fg => :tbd
      style Generic::Emph,                  :fg => :tbd
      style Generic::Error,                 :fg => :tbd
      style Generic::Heading,               :fg => :tbd
      style Generic::Inserted,              :fg => :tbd
      style Generic::Output,                :fg => :tbd
      style Generic::Prompt,                :fg => :tbd
      style Generic::Strong,                :fg => :tbd
      style Generic::Subheading,            :fg => :tbd
      style Generic::Traceback,             :fg => :tbd
      style Generic::Lineno,                :fg => :comment
    end
  end
end
