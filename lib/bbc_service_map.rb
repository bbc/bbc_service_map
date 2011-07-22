#
# Map between the multiplicity of BBC service identifiers for radio.
# Sean O'Halpin, BBC Research & Development, 2011-05-16
#
require 'yaml'

module BBCRD
  class ServiceMap
    FILENAME = "services.yml"
    FIELDS = [
              :title,           # Display title (perhaps need Short, Medium, Long from PIPs)
              :pips_id,         # PIPs, PIT, ION/Dynamite/iPlayer canonical identifiers
              :programmes_id,   # /programmes url-friendly identifiers
              :scheduler3_id,   # LiveText, PushFeeds, etc.
              :imda_id,         # Internet Media Device Alliance ID
              :imda_crid,       # Internet Media Device Alliance CRID
              :redux_id,        # BBC internal Redux
              :dab_id           # RadioDNS DAB service identifier
             ]

    class Service
      FIELDS.each do |field|
        attr_reader field
      end
      attr_reader :fm_parameters # RadioDNS FM service parameters

      def initialize(params)
        # normalize params
        params = Hash[params.map { |key, value| [key.to_sym, value] }]
        FIELDS.each do |field|
          instance_variable_set("@#{field}", params[field])
        end

        # set up RadioDNS fm service parameters where applicable
        @fm_parameters = []
        if start_freq = params[:start_freq]
          start_freq = start_freq.to_i
          end_freq   = params[:end_freq].to_i
          countries  = params[:countries]
          pi         = params[:pi]
          countries.each do |country|
            start_freq.step(end_freq, 10) do |freq|
              @fm_parameters << ["%05d" % freq, pi, country, "fm"].map(&:strip).join(".")
            end
          end
        end
      end

      def dab_topic
        dab_id.split(/\./).reverse.join("/")
      end

      def fm_topics
        fm_parameters.map{ |x| x.split(/\./).reverse.join("/")}
      end
    end

    module ClassMethods
      def init
        service_list = YAML.load(File.read(File.join(File.dirname(__FILE__), "..", "config", FILENAME))).map{ |service| Service.new(service) }
        service_map = { }

        # index each service by all of its identifiers
        service_list.each do |service|
          FIELDS.each do |attr|
            service_map[service.send(attr)] = service
          end
          service.fm_parameters.each do |fm|
            service_map[fm] = service
          end
        end
        [service_list, service_map]
      end

      def lookup(term)
        SERVICE_MAP[term]
      end

      alias :[] :lookup
    end

    extend ClassMethods
    SERVICE_LIST, SERVICE_MAP = self.init
  end
end

if __FILE__ == $0
  require 'pp'
  # pp BBCRD::ServiceMap::SERVICE_MAP
  pp BBCRD::ServiceMap.lookup("bbcr1")
  pp BBCRD::ServiceMap["radio4"].fm_parameters
  pp BBCRD::ServiceMap["1xtra"].title
end
