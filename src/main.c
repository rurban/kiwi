#include "kiwi.h"
#include "io.h"

/* usage:
 * parser base_url image_base_url < buffer
 */

int main(int argc, char **argv) {
   init();
   //file_get_contents(input, "spec/fixtures/cnn.com");
   stdin_get_contents(input_buffer);
   if(argc > 0) {
     set_base_url(argv[1]);
   }
   if(argc > 1) {
     set_image_base_url(argv[2]);
   }
   parse();
   puts(bdata(output_buffer));
   cleanup();
   return 0;
}
