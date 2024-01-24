within PNlib.Blocks;
block enablingInCon "enabling process of input transitions (continuous places)"
  parameter input Integer nIn "number of input transitions";
  input Real arcWeight[nIn] "arc weights of input transitions";
  input Real t "current marking";
  input Real maxMarks "maximum capacity";
  input Boolean TAein[nIn]
    "active input transitions which are already enabled by their input places";
  input Integer enablingType "resolution of actual conflicts";
  input Real enablingProb[nIn] "enabling probabilites of input transitions";
  input Boolean disTransition[nIn] "discrete transition?";
  input Boolean delayPassed "Does any delayPassed of a output transition";
  input Boolean active[nIn] "Are the input transitions active?";
  output Boolean TEin_[nIn] "enabled input transitions";
protected
  Boolean TEin[nIn] "enabled input transitions";
  Boolean disTAin[nIn] "discret active input transitions";
  Integer remTAin[nIn] "remaining active input transitions";
  Real cumEnablingProb[nIn] "cumulated, scaled enabling probabilities";
  Real arcWeightSum "arc weight sum";
  Integer nremTAin "number of remaining active input transitions";
  Integer nTAin "number ofactive input transitions";
  Integer k "iteration index";
  Integer posTE "possible enabled transition";
  Real randNum "uniform distributed random number";
  Real sumEnablingProbTAin
    "sum of the enabling probabilities of the active input transitions";
  Boolean endWhile;
algorithm
  when delayPassed then
    if nIn>0 then
      disTAin:=TAein and disTransition;
      arcWeightSum:=Functions.OddsAndEnds.conditionalSum(arcWeight,disTAin);  //arc weight sum of all active input transitions which are already enabled by their input places
      if t + arcWeightSum <= maxMarks or arcWeightSum==0 then  //Place has no actual conflict; all active input transitions are enabled
        TEin:=TAein;
      else                          //Place has an actual conflict
        TEin:=TAein and not disTransition;
        if enablingType==1 then     //deterministic enabling according to priorities
          arcWeightSum:=0;
          for i in 1:nIn loop
            if disTAin[i] and ((t+(arcWeightSum+arcWeight[i])<=maxMarks) or arcWeight[i]==0) then
              TEin[i]:=true;
              arcWeightSum:=arcWeightSum + arcWeight[i];
            end if;
          end for;
        else                        //probabilistic enabling according to enabling probabilities
          arcWeightSum:=0;
          remTAin:=zeros(nIn);
          nremTAin:=0;
          for i in 1:nIn loop
            if disTAin[i] then
              nremTAin:=nremTAin+1;  //number of active input transitions
              remTAin[nremTAin]:=i;  //active input transitions
            end if;
          end for;
          nTAin:=nremTAin;          //number of active input transitions
          sumEnablingProbTAin:=sum(enablingProb[remTAin[1:nremTAin]]);  //enabling probability sum of all active input transitions
          cumEnablingProb:=zeros(nIn);      //cumulative, scaled enabling probabilities
          cumEnablingProb[1]:=enablingProb[remTAin[1]]/sumEnablingProbTAin;
          for j in 2:nremTAin loop
            cumEnablingProb[j]:=cumEnablingProb[j-1]+enablingProb[remTAin[j]]/sumEnablingProbTAin;
          end for;
          //muss hier stehen sonst immer fast gleiche Zufallszahl => immer gleiches enabling
          randNum := PNlib.Functions.Random.random()/32767;
          for i in 1:nTAin loop
            randNum := PNlib.Functions.Random.random()/32767;
                                              //uniform distributed random number
            endWhile:=false;
            k:=1;
            while k<=nremTAin and not endWhile loop
                if randNum <= cumEnablingProb[k] then
                   posTE:=remTAin[k];
                   endWhile:=true;
                else
                  k:=k + 1;
                end if;
            end while;
            if t+arcWeightSum + arcWeight[posTE] <= maxMarks or arcWeight[i]==0 then
               arcWeightSum:=arcWeightSum + arcWeight[posTE];
               TEin[posTE]:=true;
            end if;
            nremTAin:=nremTAin - 1;
            if nremTAin > 0 then
              remTAin:=Functions.OddsAndEnds.deleteElementInt(remTAin,k);
              cumEnablingProb:=zeros(nIn);
              sumEnablingProbTAin:=sum(enablingProb[remTAin[1:nremTAin]]);
              if sumEnablingProbTAin>0 then
                cumEnablingProb[1]:=enablingProb[remTAin[1]]/sumEnablingProbTAin;
                for j in 2:nremTAin loop
                    cumEnablingProb[j]:=cumEnablingProb[j-1]+enablingProb[remTAin[j]]/sumEnablingProbTAin;
                end for;
              else
                  cumEnablingProb[1:nremTAin]:=fill(1/nremTAin, nremTAin);
              end if;
            end if;
        end for;
       end if;
      end if;
   else
      TEin:=fill(false, nIn);
      disTAin:=fill(false, nIn);
      remTAin:=fill(0, nIn);
      cumEnablingProb:=fill(0.0, nIn);
      arcWeightSum:=0.0;
      nremTAin:=0;
      nTAin:=0;
      k:=0;
      posTE:=0;
      randNum:=0.0;
      sumEnablingProbTAin:=0.0;
      endWhile:=false;
    end if;
  end when;
  TEin_:=TEin and active;
end enablingInCon;
