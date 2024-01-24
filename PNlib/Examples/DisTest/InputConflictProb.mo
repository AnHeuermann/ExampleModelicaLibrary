within PNlib.Examples.DisTest;
model InputConflictProb
  extends Modelica.Icons.Example;

  PNlib.PD P1(maxTokens = 2, nIn = 2, nOut = 1, enablingType = 2) annotation(Placement(transformation(extent={{10,-10},
            {30,10}})));
  PNlib.TD T1(nIn = 1) annotation(Placement(transformation(extent={{40,-10},{60,
            10}})));
  PNlib.TD T2(nIn = 1, nOut = 1) annotation(Placement(transformation(extent={{-20,10},
            {0,30}})));
  PNlib.TD T3(nIn = 1, nOut = 1) annotation(Placement(transformation(extent={{-20,-30},
            {0,-10}})));
  PNlib.PD P2(startTokens = 5, nOut = 1) annotation(Placement(transformation(extent={{-50,10},
            {-30,30}})));
  PNlib.PD P3(startTokens = 5, enablingType = 1, nOut = 1) annotation(Placement(transformation(extent={{-50,-30},
            {-30,-10}})));
  inner PNlib.Settings settings annotation(Placement(transformation(extent={{40,20},
            {60,40}})));
initial equation
  PNlib.Functions.Random.initRandom(1);
equation
  connect(P2.outTransition[1], T2.inPlaces[1]) annotation(Line(points={{-29.2,20},
          {-14.8,20}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(P3.outTransition[1], T3.inPlaces[1]) annotation(Line(points={{-29.2,-20},
          {-14.8,-20}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(T2.outPlaces[1], P1.inTransition[1]) annotation(Line(points={{-5.2,20},
          {0,20},{0,-0.5},{9.2,-0.5}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(T3.outPlaces[1], P1.inTransition[2]) annotation(Line(points={{-5.2,-20},
          {0,-20},{0,0.5},{9.2,0.5}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(T1.inPlaces[1], P1.outTransition[1]) annotation(Line(points={{45.2,0},
          {30.8,0}}, color = {0, 0, 0}, smooth = Smooth.None));
  annotation(experiment(StartTime=0.0, StopTime=10.0),
    Diagram(coordinateSystem(extent={{-60,-40},{60,40}})));
end InputConflictProb;
