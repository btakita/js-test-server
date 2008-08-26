module JsTestCore
  module Resources
    class Dir < File
      route ANY do |env, name|
        if file = file(env, name)
          file
        elsif subdir = subdir(env, name)
          subdir
        else
          raise "No file or directory found at #{relative_path}/#{name}."
        end
      end

      def get

      end

      def glob(pattern)
        expanded_pattern = absolute_path + pattern
        ::Dir.glob(expanded_pattern).map do |absolute_globbed_path|
          relative_globbed_path = absolute_globbed_path.gsub(absolute_path, relative_path)
          File.new(absolute_globbed_path, relative_globbed_path)
        end
      end

      protected
      def determine_child_paths(name)
        absolute_child_path = "#{absolute_path}/#{name}"
        relative_child_path = "#{relative_path}/#{name}"
        [absolute_child_path, relative_child_path]
      end

      def file(env, name)
        absolute_file_path, relative_file_path = determine_child_paths(name)
        if ::File.exists?(absolute_file_path) && !::File.directory?(absolute_file_path)
          Resources::File.new(env.merge(absolute_file_path, relative_file_path))
        else
          nil
        end
      end

      def subdir(env, name)
        absolute_dir_path, relative_dir_path = determine_child_paths(name)
        if ::File.directory?(absolute_dir_path)
          Resources::Dir.new(env.merge(absolute_dir_path, relative_dir_path))
        else
          nil
        end
      end
    end
  end
end