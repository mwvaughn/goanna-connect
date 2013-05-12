#!/usr/bin/perl
 
use strict;

use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use LWP::Simple;
use Getopt::Long;

##These are the necessary command line inputs
my $PROGRAM;
my $EMAIL;
my $file_type;
my $search_field;
my $ID_LIST;
my $DATABASE;
my $DATABASE2;
my $DATABASE3;
my $no_iea;
my $EXPECT;
my $WORD_SIZE;
my $MATRIX_NAME;
my $GAPCOSTS;
my $DESCRIPTIONS;
my $ALIGNMENTS;
my $bypass_prg_check;
my $error;
my $EXPECT;
my $submit;


##Below are all of the evidence codes which GOanna supports. They must be passed explicitly.

my $EXP;
my $IBA;
my $IBD;
my $IC;
my $IDA;
my $IEA;
my $IEP;
my $IGC;
my $IGI;
my $IKR;
my $IMP;
my $IPI;
my $IRD;
my $ISA;
my $ISM;
my $ISO;
my $ISS;
my $NAS;
my $ND;
my $NR;
my $RCA;
my $TAS;

GetOptions("PROGRAM=s" => \$PROGRAM, 'EMAIL=s' => \$EMAIL, 'file_type=s' => \$file_type, 'search_field=s' => \$search_field, 'ID_LIST=s' => \$ID_LIST, 'DATABASE=s' => \$DATABASE, 'DATABASE2=s' => \$DATABASE2, 'DATABASE3=s' => \$DATABASE3, 'no_iea=s' => \$no_iea, 'EXPECT=s' => \$EXPECT, 'WORD_SIZE=s' => \$WORD_SIZE,
 'GAPCOSTS=s' => \$GAPCOSTS, 'DESCRIPTIONS=i' => \$DESCRIPTIONS, 'ALIGNMENTS=i' => \$ALIGNMENTS,
  'EXP=s' => \$EXP, 'IBA=s' => \$IBA, 'IBD=s'  => \$IBD, 'IC=s' => \$IC, 'IDA=s' => \$IDA, 'IEA=s' => \$IEA, 'IEP=s' => \$IEP, 'IGC=s' => \$IGC, 'IGI=s' => \$IGI, 'IKR=s' => \$IKR, 'IMP=s' => \$IMP, 'IPI=s' => \$IPI, 'IRD=s' => \$IRD, 'ISA=s' => \$ISA, 'ISM=s' => \$ISM, 'ISO=s' => \$ISO, 'ISS=s' => \$ISS, 'NAS=s' => \$NAS, 'ND=s' => \$ND, 'NR=s' => \$NR, 'RCA=s' => \$RCA, 'TAS=s' => \$TAS,
    'bypass_prg_check=i' => \$bypass_prg_check, 'error=i' => \$error, 'EXPECT=s' => \$EXPECT);

my ($request, $content, $filename, $id, $GAP);
my @hcontent;
my $ua = LWP::UserAgent->new;
#
# open output file

#@DATABASE = split(/,/,join(',',$DATABASE));

open (OUT, ">GOanna_out.html");
 
my $file = join("", $ID_LIST);
 
my $req = (POST 'http://agbase.hpc.msstate.edu/cgi-bin/tools/GOanna.cgi',
		Content_Type => 'multipart/form-data',
		Content	  => [ 'file_type' => "fasta",
						'PROGRAM' => $PROGRAM,

						'EMAIL' => $EMAIL,
						'file_type' =>  $file_type,
						'DATABASE' => $DATABASE,
						'DATABASE' => $DATABASE2,
						'DATABASE' => $DATABASE3,
						'MATRIX_NAME' => 'BLOSUM62',
						'search_field' => 'Select ID',
						'EXPECT' => $EXPECT,
						'no_iea' => $no_iea,
						'IEA' => $IEA,
						'ISO' => $ISO,
						'EXP' => $EXP,
						'IBA' => $IBA,
						'IBD' => $IBD,
						'IC' => $IC,
						'IDA' => $IDA,
						'IEP' => $IEP,
						'IGC' => $IGC,
						'IGI' => $IGI,
						'IKR' => $IKR,
						'IMP' => $IMP,
						'IPI' => $IPI,
						'IRD' => $IRD,
						'ISA' => $ISA,
						'ISM' => $ISM,
						'ISO' => $ISO,
						'ISS' => $ISS,
						'NAS' => $NAS,
						'ND' => $ND,
						'NR' => $NR,
						'RCA' => $RCA,
						'TAS' => $TAS,
						'WORD_SIZE' => $WORD_SIZE,
						'DESCRIPTIONS' => $DESCRIPTIONS,
						'ALIGNMENTS' => $ALIGNMENTS,
						'submit' => 'BLAST',
						'GAP_COSTS' => 'Existence: 11 Extension: 1',
						'IDLIST' => ["$file"] ,
						'error' => $error,
						'bypass_prg_check' => $bypass_prg_check

					   ]
			  );
 $request = $ua->request($req);
 $content = $request->content;
my $job_id;
   print OUT $content;
	#$content =~ /job_id\=([a-z0-9]+$)/i;
	$content =~ /job_id\:\s(\S{6}\S{10})/i;
	my $job_id = $1;
	my $req_two;
	my $out_url = join( "", "http://www.agbase.msstate.edu/tmp/GOAL/", $job_id, '.zip');
	my $out_filename = join( "", $job_id, ".zip");
	#-- fetch the zip and save it as perlhowto.zip
	my $status = getstore($out_url, $out_filename);
my $maxwait = 1200;
my $initwait = 10;
my $totalwait = 0;
if (defined $job_id){

	until ( is_success($status) ){
		print "Error downloading file: $status\n";
		print "Trying again in $initwait seconds\n";
		sleep($initwait);
		$initwait = $initwait*1.2;
		if ($initwait > $maxwait){
			$initwait=$maxwait;

}
		$totalwait=$totalwait+$initwait;
		$status = getstore($out_url, $out_filename);
if ($totalwait > 36000) {
print "Maximum wait time exceeded; either GOanna is down or the submission will never finish.";
exit;
}
}
if ( is_success($status) ) {
			print "The GOanna file downloaded correctly\nIts name is $out_filename\n";
			sleep(3);
			unlink "GOanna_out.html";
			exit;
			}
}

else {
print "The submission failed, likely because of bad parameters\n";
exit;
}



