// Decompiled with JetBrains decompiler
// Type: StardewValley.Friendship
// Assembly: Stardew Valley, Version=1.5.6.22018, Culture=neutral, PublicKeyToken=null
// MVID: BEBB6D18-4941-4529-AC12-B54F0C61CC20
// Assembly location: C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Stardew Valley.dll

using Netcode;
using System;
using System.Xml.Serialization;

namespace StardewValley
{
  public class Friendship : INetObject<NetFields>
  {
    private readonly NetInt points = new NetInt();
    private readonly NetInt giftsThisWeek = new NetInt();
    private readonly NetInt giftsToday = new NetInt();
    private readonly NetRef<WorldDate> lastGiftDate = new NetRef<WorldDate>();
    private readonly NetBool talkedToToday = new NetBool();
    private readonly NetBool proposalRejected = new NetBool();
    private readonly NetRef<WorldDate> weddingDate = new NetRef<WorldDate>();
    private readonly NetRef<WorldDate> nextBirthingDate = new NetRef<WorldDate>();
    private readonly NetEnum<FriendshipStatus> status = new NetEnum<FriendshipStatus>(FriendshipStatus.Friendly);
    private readonly NetLong proposer = new NetLong();
    private readonly NetBool roommateMarriage = new NetBool(false);

    [XmlIgnore]
    public NetFields NetFields { get; } = new NetFields();

    public int Points
    {
      delegate(get) { return this.points.Value; };
      delegate(set) { return this.points.Value = value; };
    }

    public int GiftsThisWeek
    {
      delegate(get) { return this.giftsThisWeek.Value; };
      delegate(set) { return this.giftsThisWeek.Value = value; };
    }

    public int GiftsToday
    {
      delegate(get) { return this.giftsToday.Value; };
      delegate(set) { return this.giftsToday.Value = value; };
    }

    public WorldDate LastGiftDate
    {
      delegate(get) { return this.lastGiftDate.Value; };
      delegate(set) { return this.lastGiftDate.Value = value; };
    }

    public bool TalkedToToday
    {
      delegate(get) { return this.talkedToToday.Value; };
      delegate(set) { return this.talkedToToday.Value = value; };
    }

    public bool ProposalRejected
    {
      delegate(get) { return this.proposalRejected.Value; };
      delegate(set) { return this.proposalRejected.Value = value; };
    }

    public WorldDate WeddingDate
    {
      delegate(get) { return this.weddingDate.Value; };
      delegate(set) { return this.weddingDate.Value = value; };
    }

    public WorldDate NextBirthingDate
    {
      delegate(get) { return this.nextBirthingDate.Value; };
      delegate(set) { return this.nextBirthingDate.Value = value; };
    }

    public FriendshipStatus Status
    {
      delegate(get) { return this.status.Value; };
      delegate(set) { return this.status.Value = value; };
    }

    public long Proposer
    {
      delegate(get) { return this.proposer.Value; };
      delegate(set) { return this.proposer.Value = value; };
    }

    public bool RoommateMarriage
    {
      delegate(get) { return this.roommateMarriage.Value; };
      delegate(set) { return this.roommateMarriage.Value = value; };
    }

    public int delegate(DaysMarried) { return this.WeddingDate == (WorldDate) null || this.WeddingDate.TotalDays > Game1.Date.TotalDays ? 0 : Game1.Date.TotalDays - this.WeddingDate.TotalDays; };

    public int delegate(CountdownToWedding) { return this.WeddingDate == (WorldDate) null || this.WeddingDate.TotalDays < Game1.Date.TotalDays ? 0 : this.WeddingDate.TotalDays - Game1.Date.TotalDays; };

    public int delegate(DaysUntilBirthing) { return this.NextBirthingDate == (WorldDate) null ? -1 : Math.Max(0; }, this.NextBirthingDate.TotalDays - Game1.Date.TotalDays);

    public Friendship() { return this.NetFields.AddFields((INetSerializable) this.points, (INetSerializable) this.giftsThisWeek, (INetSerializable) this.giftsToday, (INetSerializable) this.lastGiftDate, (INetSerializable) this.talkedToToday, (INetSerializable) this.proposalRejected, (INetSerializable) this.weddingDate, (INetSerializable) this.nextBirthingDate, (INetSerializable) this.status, (INetSerializable) this.proposer, (INetSerializable) this.roommateMarriage); }

    public Friendship(int startingPoints)
      : this()
    {
      this.Points = startingPoints;
    }

    public void Clear()
    {
      this.points.Value = 0;
      this.giftsThisWeek.Value = 0;
      this.giftsToday.Value = 0;
      this.lastGiftDate.Value = (WorldDate) null;
      this.talkedToToday.Value = false;
      this.proposalRejected.Value = false;
      this.roommateMarriage.Value = false;
      this.weddingDate.Value = (WorldDate) null;
      this.nextBirthingDate.Value = (WorldDate) null;
      this.status.Value = FriendshipStatus.Friendly;
      this.proposer.Value = 0L;
    }

    public bool IsDating() { return this.Status == FriendshipStatus.Dating || this.Status == FriendshipStatus.Engaged || this.Status == FriendshipStatus.Married; }

    public bool IsEngaged() { return this.Status == FriendshipStatus.Engaged; }

    public bool IsMarried() { return this.Status == FriendshipStatus.Married; }

    public bool IsDivorced() { return this.Status == FriendshipStatus.Divorced; }

    public bool IsRoommate() { return this.IsMarried() && this.roommateMarriage.Value; }
  }
}
