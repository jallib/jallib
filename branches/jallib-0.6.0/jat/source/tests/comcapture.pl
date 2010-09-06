#comcapture.pl
use strict;

use Getopt::Std;

my $mysport="COM1";

my $port;

{  # start of main  
   my $char;

#   print "Capture from COM port.\n";

   my %opt; 
   getopts('hp:f:', \%opt);   # ':' means: takes param

#   # dupm params
#   foreach (sort keys %opt) {   
#      print "$_ -> $opt{$_}\n"
#   }
      
   if($opt{"h"} ne ""){
   	print "# Capture input from com port or file and filter\n";
   	print "#     one run of test-info, determined by tag\n";
   	print "#     Result is printed to stdout\n";
   	print "#\n";
   	print "# -h This screen.\n";
   	print "# -p Serial port name or number (default COM1).\n";
   	print "# -f filename.\n";
   	print "#\n";
   	print "# Example: comcapture.pl -p COM2\n"; 
   	print "#    or    comcapture.pl -f file.txt\n"; 
   	exit(0);
   }

   if($opt{"p"} ne ""){
   	$mysport=$opt{"p"};
   }

#   print "com: $mysport %s\n", $opt{"p"};   
   
   if ($opt{"f"} ne "") {
      # input from file 
      my $filename = $opt{"f"}; # less cryptic
      
      open (FILE, "< $filename") or die "Can't open $filename : $!";
   
      while (<FILE>) {
         if (OutputFilter($_)) {
            last;
         } 
      }
      exit(0);
   }
   


   # Set up the serial port for Windows
   use Win32::SerialPort;
   my $port = Win32::SerialPort->new($mysport); #change to your com port
   
   #setup serial port for Linux
   #use Device::SerialPort;
   #my $port = Device::SerialPort->new("/"); #change to your com port

   #port configuration  115200/8/N/1
   $port->databits(8);
   $port->baudrate(115200);
   $port->parity("none");
   $port->stopbits(1);
   $port->handshake("none");
   $port->buffers(1, 1); #1 byte or it buffers everything forever
   $port->write_settings		|| undef $port; #set
   unless ($port)			{ die "couldn't write_settings"; }
    
   #$port->pulse_rts_on(1000);  

   # active rts for hardware passthrough on modified wisp
   $port->rts_active(1);  


#   print "Start reading.\n";
   my $buffer; 
   my ($i, $string);  
   my $done = 0;
   for (;!$done;) {
      select(undef,undef,undef, .2); #sleep for 0.2 fraction of second for data to 
      $buffer .= $port->read(4096);

      for (;!$done;) {
         # pop lines from buffer
         $i = index($buffer, "\n");
         if ($i > -1) {
            $string = substr($buffer, 0, $i+1);
            $buffer = substr($buffer, $i+1); 
            
            # here we have a line
            if (OutputFilter($string)) {
               $done = 1;
            } 
            next; # next line from buffer
         }
         # no more full lines
         last;
      } 
   }
      
   print;
}  # end of main


my $FilterState = 0;
sub OutputFilter
{  my $instring = shift;

   my $triggermsg = (index($instring, "-START-OF-TEST-") != -1);

#   print("$triggermsg + $FilterState + $instring");

   if (($FilterState == 0) && ($triggermsg == 1)) {
      # found startflag we were waiting for
      $FilterState = 1;   
      print $instring;
      return;
   }                   
   
   if ($FilterState == 1) {
      # print until 
      if ($triggermsg) {
         $FilterState = 2;
      } else {
         print $instring;
      }
   }   
   # FilterState == 2 is to stop printing or re-triggering, indicate when ready.
   
   if ($FilterState == 2) {
      return 1; # done
   } else {
      return 0; # still busy
   }
      
      
}   


# ###############################
# #
# #
# # 		Helper functions
# #
# #
# ###############################
# 
# #Returns to user terminal mode from raw binary mode
# #resets hardware  and exits binary mode
# #returns BBIO version, or 0 for failure
# sub exitBinMode{
# 
# 	#make sure we're in BBIO (not spi, etc) binmode before sending reset command
# 	my $ver=&enterBinMode; #return to BBIO mode (0x00), (should get BBIOx)
# 	
# 	#if we're ready, send the reset command
# 	if($ver){
# 		$port->write("\x0F"); #send 0x0f to do a hardware reset
# 		select(undef,undef,undef, .02); #sleep for fraction of second for data to arrive #sleep(1);
# 		$char= $port->read(1); #look for BBIOx
# 		if($char && ($char eq "\x01") ){
# 			return 1; #return version number
# 		}
# 
# 	}
# 	return $ver;
# }
# 
# #this function puts the Bus Pirate in binmode
# #returns binmode version number, 0 for failure
# sub enterBinMode {
# #it could take 1 or 20 0x00 to enter Bus Pirate binary mode
# #it will take 20 if we're currently at the user terminal mode
# #it will only take 1 if the Bus Pirate is already in a raw mode
# #BP replies BBIOx where x is the protocol version
# 	
# 	my $count=40;
# 	my $char="";
# 	while($count){
# 		$port->write("\x00"); #send 0x00
# 		select(undef,undef,undef, .02); #sleep for fraction of second for data to arrive #sleep(1);
# 		$char= $port->read(5); #look for BBIOx
# 		if($char && ($char eq "BBIO1") ){
# 			return 1; #return version number
# 		}
# 		$count--; #if timeout, then try again
# 	}
# 	return 0; #for fail, version number for success
# }
# 
# sub enterBinModefast {
# #it could take 1 or 20 0x00 to enter Bus Pirate binary mode
# #this just blasts 20 0x00, then reads five and discards the rest. 
# #BP replies BBIOx where x is the protocol version
# 	
# 	my $count=20;
# 	my $char="";
# 	
# 	while($count){
# 		$port->write("\x00"); #send 0x00
# 		$count--;
# 	}
# 	
# 	select(undef,undef,undef, .02); #sleep for fraction of second for data to arrive #sleep(1);
# 	
# 	$char= $port->read(5); #look for BBIOx
# 	
# 	if($char && ($char eq "BBIO1")){
# 		#print "(" . $char . ") "; #debug
# 		return 1; #return version number
# 	}
# 
# 	$char= $port->read(); #flush buffer, could have 20 x 0x00
# 		
# 	return 0; #for fail, version number for success
# }
# 
# #The Bus Pirate might be stuck in a configuration menu or something when we connect
# #send <enter> 10 times, then #<enter> to reset the Bus Pirate
# #need to pause and flush buffer when complete
# sub userTerminalReset{
# 	$port->write("\n\n\n\n\n\n\n\n\n\n#\n");
# 	#now flush garbage from read buffer
# }
# 
# #debug variable transformation
# #$char =~ s/\cM/\r\n/; #debug