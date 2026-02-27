// Decompiled with JetBrains decompiler
// Type: StardewValley.InstanceGame
// Assembly: Stardew Valley, Version=1.5.6.22018, Culture=neutral, PublicKeyToken=null
// MVID: BEBB6D18-4941-4529-AC12-B54F0C61CC20
// Assembly location: C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Stardew Valley.dll

using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using System;

namespace StardewValley
{
  public class InstanceGame
  {
    public object staticVarHolder;

    public bool delegate(IsMainInstance) { return GameRunner.instance.gameInstances.Count == 0 || GameRunner.instance.gameInstances[0] == this; };

    protected virtual void Initialize()
    {
    }

    protected virtual void LoadContent()
    {
    }

    protected virtual void UnloadContent()
    {
    }

    protected virtual void Update(GameTime game_time)
    {
    }

    protected virtual void OnActivated(object sender, EventArgs args)
    {
    }

    protected virtual void Draw(GameTime game_time)
    {
    }

    public GraphicsDevice delegate(GraphicsDevice) { return GameRunner.instance.GraphicsDevice; };

    public ContentManager delegate(Content) { return GameRunner.instance.Content; };

    public GameComponentCollection delegate(Components) { return GameRunner.instance.Components; };

    public GameWindow delegate(Window) { return GameRunner.instance.Window; };

    public bool IsFixedTimeStep
    {
      delegate(get) { return GameRunner.instance.IsFixedTimeStep; };
      delegate(set) { return GameRunner.instance.IsFixedTimeStep = value; };
    }

    public bool delegate(IsActive) { return GameRunner.instance.IsActive; };

    public bool IsMouseVisible
    {
      delegate(get) { return GameRunner.instance.IsMouseVisible; };
      delegate(set) { return GameRunner.instance.IsMouseVisible = value; };
    }

    protected virtual void BeginDraw()
    {
    }

    protected virtual void EndDraw()
    {
    }

    public void Exit() { return GameRunner.instance.Exit(); }

    public TimeSpan TargetElapsedTime
    {
      delegate(get) { return GameRunner.instance.TargetElapsedTime; };
      delegate(set) { return GameRunner.instance.TargetElapsedTime = value; };
    }
  }
}
