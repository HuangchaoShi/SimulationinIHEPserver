#include <iostream>
#include <fstream>

#include "TFile.h"
#include "TFolder.h"
#include "TH1F.h"
#include "TLegend.h"
#include "TCanvas.h"
#include "TString.h"

using namespace std;
const double pi = 3.141592654;
const double nWireRadius[] = {79., 91., 103., 115., 127., 139., 151., 163., 197.1, 213.3, 229.5, 245.7, 261.9, 278.1, 294.3, 310.5, 326.7, 342.9, 359.1, 375.3, 391.5, 407.7, 423.9, 440.1, 456.3, 472.5, 488.7, 504.9, 521.1, 537.3, 554.5, 569.7, 585.9, 602.1, 618.3, 634.5, 650.7, 666.9, 683.1, 699.3, 715.5, 731.7, 747.9, 764.1};
const double nWireLenth[] = {786, 798, 810, 822, 834, 846, 858, 870, 1092, 1092, 1282, 1282, 1462, 1462, 1642, 1642, 1822, 1822, 1972, 1972, 2174, 2180, 2186, 2192, 2198, 2204, 2210, 2216, 2222, 2228, 2234, 2240, 2246, 2252, 2258, 2264, 2270, 2276, 2282, 2288, 2294, 2300, 2306};
const TString source[] = {"touse", "tousp", "coule", "coulp", "breme", "bremp"}
using namespace std;

void drawlayers(int isource, TH1F* hAR, TH1F *hTotal){
  int laymax=43;
  int runmin = 100;
  int runmax = 109;
  Double_t layhit[43] = {0};
  Double_t layEvt[43] = {0};
  Double_t CR[43] = {0};
  Double_t Totalhit[43] = {0};

  for(int run = runmin; run <= runmax; run=run+1){
    TString sHistName = Form("/hist_%d.root",run);
    TString sHistFileName = "../Run/"+source[isource]+sHistName;
    cout<<sHistFileName<<endl;
    TFile *f1 = new TFile(sHistFileName);
    TFolder* fd = (TFolder*)f1->Get("all");
    for(int lay =0; lay < laymax; lay ++){
        TString fname1=Form("nhitRawLay%02d", lay);
        TH1F *hInn = (TH1F*)fd->FindObjectAny(fname1);
        if(!(hInn)) continue;
        cout << fname1 << endl;
        int nEvt = (int)hInn->GetEntries();
        double nhit = hInn->GetMean();
        layhit[lay] += nhit*nEvt;
        layEvt[lay] += nEvt;
    }
    f1->Close(); 
  }
  for (int lay = 0; lay < laymax;  lay ++){
      cout<<"lay:"<<lay<<"; layhit[lay]:"<<layhit[lay]<<endl;
      cout<<"evt:"<<layEvt[lay]<<endl;
  }
 
  double scale=10.0;
  for (int lay = 0; lay < laymax;  lay ++){
      CR[lay] = layhit[lay]*scale/(pi*2*nWireRadius[lay]*nWireLenth[lay]*0.01);
      Totalhit[lay] = layhit[lay]*scale;
  }
  
  for(int i=0;i<43;i++){
    hAR->Fill(nWireRadius[i],CR[i]);
    hTotal->Fill(nWireRadius[i],Totalhit[i]);
  }
}

void draw_total(){
  gStyle->SetOptStat(0);
  gStyle->SetFrameLineWidth(3);

  TH1F *hARtouse=new TH1F("hARtouse","",43,nWireRadius);
  TH1F *hTotaltouse=new TH1F("hTotaltouse","",43,nWireRadius);
  drawlayers(0,hARtouse,hTotaltouse); 
  
  TH1F *hARtousp=new TH1F("hARtousp","",43,nWireRadius);
  TH1F *hTotaltousp=new TH1F("hTotaltousp","",43,nWireRadius);
  drawlayers(1,hARtousp,hTotaltousp);

  TH1F *hARcoule=new TH1F("hARcoule","",43,nWireRadius);
  TH1F *hTotalcoule=new TH1F("hTotalcoule","",43,nWireRadius);
  drawlayers(2,hARcoule,hTotalcoule);

  TH1F *hARcoulp=new TH1F("hARcoulp","",43,nWireRadius);
  TH1F *hTotalcoulp=new TH1F("hTotalcoulp","",43,nWireRadius);
  drawlayers(3,hARcoulp,hTotalcoulp);

  TH1F *hARbreme=new TH1F("hARbreme","",43,nWireRadius);
  TH1F *hTotalbreme=new TH1F("hTotalbreme","",43,nWireRadius);
  drawlayers(4,hARbreme,hTotalbreme);

  TH1F *hARbremp=new TH1F("hARbremp","",43,nWireRadius);
  TH1F *hTotalbremp=new TH1F("hTotalbremp","",43,nWireRadius);
  drawlayers(5,hARbremp,hTotalbremp);

  //Draw counting rate per area 
  hTotaltouse->SetFillColor(kRed);
  hTotaltousp->SetFillColor(kRed);   
  hTotalcoule->SetFillColor(kGreen);
  hTotalcoulp->SetFillColor(kGreen);
  hTotalbreme->SetFillColor(kMagenta);
  hTotalbremp->SetFillColor(kMagenta);

  hTotaltouse->SetXTitle("Radius/mm");
  hTotaltouse->SetYTitle("Total Rate/Hz");
  hTotaltouse->GetYaxis()->SetRangeUser(0,2000000);
  
  TCanvas *c1 = new TCanvas("c1");
  THStack *hs_all = new THStack("hs_all","");
  hs_all->Add(hTotaltouse);
  hs_all->Add(hTotaltousp);
  hs_all->Add(hTotalcoule);
  hs_all->Add(hTotalcoulp);
  hs_all->Add(hTotalbreme);
  hs_all->Add(hTotalbremp);

  TLegend *leg1 =new TLegend(0.5,0.65,0.85,0.85);
  leg1->SetFillColor(0);
  leg1->SetBorderSize(0);
  leg1->SetTextSize(0.03);
  leg1->AddEntry(hTotaltouse,"Touschek","f");
  leg1->AddEntry(hTotalcoule,"Coulomb","f");
  leg1->AddEntry(hTotalbreme,"Bremsstrahlung","f");

  hTotaltouse->Draw();
  hs_all->Draw("same");
  leg1->Draw();
}
