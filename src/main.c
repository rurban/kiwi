#include "kiwi.h"
#include "io.h"

int main(int argc, char **argv) {
   if(argv[1] && (strcmp(argv[1],"-h") == 0)) {
       puts("Usage:");
       puts("  parser [-h][-f filename] [base_url [image_base_url]] [< wikitext]");
       return 0;
   }
   init();
   if(argv[1] && argv[2] && (strcmp(argv[1],"-f") == 0)) {
       file_get_contents(input_buffer, argv[2]);
   } else {
       stdin_get_contents(input_buffer);
   }
   if(argc > 0) {
     set_base_url(argv[1]);
   }
   if(argc > 1) {
     set_image_base_url(argv[2]);
   }
   parse();
   puts((char *)output_buffer->data);
   cleanup();
   return 0;
}
